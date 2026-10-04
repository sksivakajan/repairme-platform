"""Builds the app's logo assets from the original RepairMe icon artwork.

    python tool/make_brand_assets.py

Source: tool/brand_source/repairme_icon_dark.png (the mark in white and yellow
on a black rounded square). Writes:
  assets/images/logo_mark.png        mark for light backgrounds (black + yellow)
  assets/images/logo_mark_light.png  mark for dark backgrounds (white + yellow)
  android launcher icons (legacy + adaptive foreground) in android/app/src/main/res
"""

from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "tool" / "brand_source" / "repairme_icon_dark.png"
RES = ROOT / "android" / "app" / "src" / "main" / "res"
INK = np.array([17, 17, 17], dtype=float)
DENSITIES = {"mdpi": 1, "hdpi": 1.5, "xhdpi": 2, "xxhdpi": 3, "xxxhdpi": 4}


def load():
    return np.asarray(Image.open(SOURCE).convert("RGBA")).astype(float)


def extract_mark(icon):
    """Keys out the dark background, returning the mark as straight RGBA."""
    rgb = icon[..., :3]
    background = np.median(rgb[icon[..., 3] > 250].reshape(-1, 3), axis=0)
    brightness = rgb.max(axis=2)
    alpha = np.clip((brightness - 45) / (200 - 45), 0, 1)
    alpha[icon[..., 3] < 250] = 0  # outside the rounded square

    safe = np.where(alpha > 0, alpha, 1)[..., None]
    colour = np.clip((rgb - (1 - alpha[..., None]) * background) / safe, 0, 255)

    ys, xs = np.where(alpha > 0.1)
    pad = 12
    box = (xs.min() - pad, ys.min() - pad, xs.max() + pad, ys.max() + pad)
    colour = colour[box[1]:box[3], box[0]:box[2]]
    alpha = alpha[box[1]:box[3], box[0]:box[2]]

    # Square canvas so the mark scales evenly.
    h, w = alpha.shape
    side = max(h, w)
    out = np.zeros((side, side, 4))
    oy, ox = (side - h) // 2, (side - w) // 2
    out[oy:oy + h, ox:ox + w, :3] = colour
    out[oy:oy + h, ox:ox + w, 3] = alpha * 255
    return out


def to_image(rgba, size=None):
    image = Image.fromarray(np.clip(rgba, 0, 255).astype(np.uint8), "RGBA")
    return image.resize((size, size), Image.LANCZOS) if size else image


def on_light(mark):
    """White parts become ink so the mark reads on white."""
    out = mark.copy()
    rgb = out[..., :3]
    whiteish = rgb[..., 2] > 140  # yellow has almost no blue
    rgb[whiteish] = INK
    return out


def main():
    mark = extract_mark(load())
    images = ROOT / "assets" / "images"
    images.mkdir(parents=True, exist_ok=True)
    to_image(on_light(mark), 768).save(images / "logo_mark.png", optimize=True)
    to_image(mark, 768).save(images / "logo_mark_light.png", optimize=True)

    light = to_image(mark)
    for density, scale in DENSITIES.items():
        folder = RES / f"mipmap-{density}"
        # Legacy icon: the mark on a black rounded square.
        size = round(48 * scale)
        icon = Image.open(SOURCE).convert("RGBA")
        bbox = icon.getbbox()
        icon.crop(bbox).resize((size, size), Image.LANCZOS).save(folder / "ic_launcher.png", optimize=True)
        # Adaptive foreground: 108dp canvas, mark within the 66dp safe zone.
        canvas = round(108 * scale)
        inner = round(canvas * 0.56)
        foreground = Image.new("RGBA", (canvas, canvas), (0, 0, 0, 0))
        offset = (canvas - inner) // 2
        foreground.paste(light.resize((inner, inner), Image.LANCZOS), (offset, offset))
        foreground.save(folder / "ic_launcher_foreground.png", optimize=True)
    print("done")


if __name__ == "__main__":
    main()
