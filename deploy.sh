#!/usr/bin/env bash
# Deploy cohesivetechnology.co.uk to S3 + CloudFront.
#
# Prerequisites:
#   - aws CLI installed and authenticated (uses default credentials unless AWS_PROFILE is set)
#   - S3 bucket exists, fronted by a CloudFront distribution with the custom domain
#   - ACM cert in us-east-1 attached to the distribution
#
# Override the defaults via env vars, e.g.:
#   S3_BUCKET=foo CLOUDFRONT_DISTRIBUTION_ID=ETO... ./deploy.sh

set -euo pipefail

S3_BUCKET="${S3_BUCKET:-cohesivetechnology.co.uk}"
AWS_REGION="${AWS_REGION:-eu-west-2}"
CLOUDFRONT_DISTRIBUTION_ID="${CLOUDFRONT_DISTRIBUTION_ID:-EDBWZ35WCVZFC}"

cd "$(dirname "$0")"

echo "==> Syncing site to s3://${S3_BUCKET}/ in ${AWS_REGION}"
aws s3 sync . "s3://${S3_BUCKET}/" \
  --region "${AWS_REGION}" \
  --delete \
  --acl public-read \
  --exclude ".git/*" \
  --exclude ".gitignore" \
  --exclude "CLAUDE.md" \
  --exclude "deploy.sh" \
  --exclude "*.md"

echo "==> Invalidating CloudFront distribution ${CLOUDFRONT_DISTRIBUTION_ID}"
aws cloudfront create-invalidation \
  --distribution-id "${CLOUDFRONT_DISTRIBUTION_ID}" \
  --paths "/*" \
  > /dev/null

echo "==> Deploy complete."
