
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
    {
      role   = "roles/pubsub.viewer"
      member = "serviceAccount:example@example.gserviceaccount.com"
    }
  ]
  pull_subscription_iam_binding = false
  pull_subscription_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "user:example@example.com"
    },
    {
      role   = "roles/pubsub.viewer"
      member = "serviceAccount:example@example.gserviceaccount.com"
    }
  ]
  push_subscription_iam_binding = false
  push_subscription_roles_members = [
    {
      role   = "roles/pubsub.subscriber"
      member = "user:example@example.com"
    },
    {
      role   = "roles/pubsub.viewer"
      member = "serviceAccount:example@example.gserviceaccount.com"
    }
  ]
  pull_subscriptions = [
    {
      name                         = "pull"
      ack_deadline_seconds         = 10
      enable_exactly_once_delivery = true
    },
  ]
  schema = {
    name       = "example"
    type       = "AVRO"
    encoding   = "JSON"
    definition = "{\n  \"type\" : \"record\",\n  \"name\" : \"Avro\",\n  \"fields\" : [\n    {\n      \"name\" : \"StringField\",\n      \"type\" : \"string\"\n    },\n    {\n      \"name\" : \"IntField\",\n      \"type\" : \"int\"\n    }\n  ]\n}\n"
  }

}