provider "google" {
  project     = var.gcp_project_id
  credentials = var.gcp_credentials
  region      = var.gcp_region
  zone        = var.gcp_zone
}

# ------------------------------------------------------------------------------
# Module
# ------------------------------------------------------------------------------

module "pubsub" {
  source = "../../"

  project_id           = "clouddrove-1"
  topic                = "topic-1"
  create_topic         = true
  create_subscriptions = true
  topic_kms_key_name   = ""
  topic_iam_binding    = true
  topic_iam_binding_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "user:example@example.com"
    },
  ]
  pull_subscription_iam_binding = false
  pull_subscription_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "user:example@example.com"
    },
  ]
  push_subscription_iam_binding = false
  push_subscription_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "user:example@example.com"
    },
  ]

  push_subscriptions = [
    {
      name                 = "push"
      push_endpoint        = ""
      x-goog-version       = "v1beta1"
      ack_deadline_seconds = 20
      expiration_policy    = "1209600s"
    },
  ]
}