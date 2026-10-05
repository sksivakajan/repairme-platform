-- CreateEnum
CREATE TYPE "gender" AS ENUM ('MALE', 'FEMALE', 'PREFER_NOT_TO_SAY');

-- CreateEnum
CREATE TYPE "membership_type" AS ENUM ('STANDARD');

-- CreateEnum
CREATE TYPE "account_status" AS ENUM ('ACTIVE', 'DELETED');

-- AlterTable
ALTER TABLE "addresses" ADD COLUMN     "contact_name" TEXT,
ADD COLUMN     "contact_phone" TEXT,
ADD COLUMN     "district" TEXT,
ADD COLUMN     "instructions" TEXT;

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "account_status" "account_status" NOT NULL DEFAULT 'ACTIVE',
ADD COLUMN     "birthday" DATE,
ADD COLUMN     "deleted_at" TIMESTAMPTZ(3),
ADD COLUMN     "email" TEXT,
ADD COLUMN     "first_name" TEXT,
ADD COLUMN     "gender" "gender",
ADD COLUMN     "last_name" TEXT,
ADD COLUMN     "membership_type" "membership_type" NOT NULL DEFAULT 'STANDARD',
ADD COLUMN     "notify_booking_updates" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "notify_offers" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "notify_payment_updates" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "notify_repairme_updates" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "notify_service_reminders" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "profile_completed_at" TIMESTAMPTZ(3),
ADD COLUMN     "profile_photo_key" TEXT;

-- CreateTable
CREATE TABLE "emergency_contacts" (
    "id" UUID NOT NULL DEFAULT uuidv7(),
    "user_id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "relationship" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "emergency_contacts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "legal_acceptances" (
    "id" UUID NOT NULL DEFAULT uuidv7(),
    "user_id" UUID NOT NULL,
    "document_type" TEXT NOT NULL,
    "document_version" TEXT NOT NULL,
    "accepted_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "legal_acceptances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "account_deletion_feedback" (
    "id" UUID NOT NULL DEFAULT uuidv7(),
    "reason" TEXT NOT NULL,
    "details" TEXT,
    "requested_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "account_deletion_feedback_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "emergency_contacts_user_id_idx" ON "emergency_contacts"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "legal_acceptances_user_id_document_type_document_version_key" ON "legal_acceptances"("user_id", "document_type", "document_version");

-- AddForeignKey
ALTER TABLE "emergency_contacts" ADD CONSTRAINT "emergency_contacts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "legal_acceptances" ADD CONSTRAINT "legal_acceptances_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
