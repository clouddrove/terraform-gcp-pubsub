locals {
  default_ack_deadline_seconds = 10
}

# ------------------------------------------------------------------------------
# Resource: google_pubsub_topic_iam_member
# ------------------------------------------------------------------------------

resource "google_pubsub_topic_iam_member" "topic_binding" {
  for_each =  length(var.topic_iam_binding_roles_members) > 0 ? { for idx, binding in var.topic_iam_binding_roles_members : idx => binding } : {}

  project = var.project_id
  topic   = var.create_topic ? google_pubsub_topic.pubsub_topic[0].name : var.topic
  role    = each.value.role
  member  = each.value.member

  depends_on = [
    google_pubsub_topic.pubsub_topic,
  ]
}

# ------------------------------------------------------------------------------
# Resource: google_pubsub_subscription_iam_member
# ------------------------------------------------------------------------------

resource "google_pubsub_subscription_iam_member" "pull_subscription_binding" {
 for_each = length(var.pull_subscription_roles_members) > 0 ? { for idx, binding in var.pull_subscription_roles_members : idx => binding } : {}

  project      = var.project_id
  subscription = "pull"
  role         = each.value.role
  member       = each.value.member

  depends_on = [
    google_pubsub_subscription.pull_subscriptions,
  ]

  lifecycle {
    replace_triggered_by = [google_pubsub_subscription.pull_subscriptions]
  }
}

# ------------------------------------------------------------------------------
# Resource: google_pubsub_subscription_iam_member (push_subscription_binding)
# ------------------------------------------------------------------------------

resource "google_pubsub_subscription_iam_member" "push_subscription_binding" {
  for_each = var.push_subscription_iam_binding && length(var.push_subscription_roles_members) > 0 ? { for idx, binding in var.push_subscription_roles_members : idx => binding } : {}

  project      = var.project_id
  subscription = "push"
  role         = each.value.role
  member       = each.value.member

  depends_on = [
    google_pubsub_subscription.push_subscriptions,
  ]

  lifecycle {
    replace_triggered_by = [google_pubsub_subscription.push_subscriptions]
  }
}

# ------------------------------------------------------------------------------
# Resource: google_pubsub_schema
# ------------------------------------------------------------------------------

resource "google_pubsub_schema" "schema" {
  count      = var.schema != null ? 1 : 0
  project    = var.project_id
  name       = var.schema.name
  type       = var.schema.type
  definition = var.schema.definition
}

# ------------------------------------------------------------------------------
# Resource: google_pubsub_topic
# ------------------------------------------------------------------------------

resource "google_pubsub_topic" "pubsub_topic" {
  count                      = var.create_topic ? 1 : 0
  project                    = var.project_id
  name                       = var.topic
  labels                     = var.topic_labels
  kms_key_name               = var.topic_kms_key_name
  message_retention_duration = var.topic_message_retention_duration

  dynamic "message_storage_policy" {
    for_each = var.message_storage_policy
    content {
      allowed_persistence_regions = message_storage_policy.key == "allowed_persistence_regions" ? message_storage_policy.value : null
    }
  }

  dynamic "schema_settings" {
    for_each = var.schema != null ? [var.schema] : []
    content {
      schema   = google_pubsub_schema.schema[0].id
      encoding = lookup(schema_settings.value, "encoding", null)
    }
  }
  depends_on = [google_pubsub_schema.schema]
}

# ------------------------------------------------------------------------------
# Resource: google_pubsub_subscription (pull_subscriptions)
# ------------------------------------------------------------------------------

resource "google_pubsub_subscription" "pull_subscriptions" {
  for_each = var.create_subscriptions ? { for i in var.pull_subscriptions : i.name => i } : {}

  name                         = each.value.name
  topic                        = var.create_topic ? google_pubsub_topic.pubsub_topic[0].name : var.topic
  project                      = var.project_id
  labels                       = var.subscription_labels
  enable_exactly_once_delivery = lookup(each.value, "enable_exactly_once_delivery", null)
  ack_deadline_seconds         = lookup(each.value, "ack_deadline_seconds", local.default_ack_deadline_seconds)
  message_retention_duration   = lookup(each.value, "message_retention_duration", null)
  retain_acked_messages        = lookup(each.value, "retain_acked_messages", null)
  filter                       = lookup(each.value, "filter", null)
  enable_message_ordering      = lookup(each.value, "enable_message_ordering", null)

  dynamic "expiration_policy" {
    for_each = contains(keys(each.value), "expiration_policy") ? [each.value.expiration_policy] : []
    content {
      ttl = expiration_policy.value
    }
  }

  dynamic "dead_letter_policy" {
    for_each = (lookup(each.value, "dead_letter_topic", "") != "") ? [each.value.dead_letter_topic] : []
    content {
      dead_letter_topic     = lookup(each.value, "dead_letter_topic", "")
      max_delivery_attempts = lookup(each.value, "max_delivery_attempts", "5")
    }
  }

  dynamic "retry_policy" {
    for_each = (lookup(each.value, "maximum_backoff", "") != "") ? [each.value.maximum_backoff] : []
    content {
      maximum_backoff = lookup(each.value, "maximum_backoff", "")
      minimum_backoff = lookup(each.value, "minimum_backoff", "")
    }
  }

  depends_on = [
    google_pubsub_topic.pubsub_topic
  ]
}

# ------------------------------------------------------------------------------
# Resource: google_pubsub_subscription (push_subscriptions)
# ------------------------------------------------------------------------------

resource "google_pubsub_subscription" "push_subscriptions" {
  for_each = var.create_subscriptions ? { for i in var.push_subscriptions : i.name => i } : {}

  name                       = each.value.name
  topic                      = var.create_topic ? google_pubsub_topic.pubsub_topic[0].name : var.topic
  project                    = var.project_id
  labels                     = var.subscription_labels
  ack_deadline_seconds       = lookup(each.value, "ack_deadline_seconds", local.default_ack_deadline_seconds)
  message_retention_duration = lookup(each.value, "message_retention_duration", null)
  retain_acked_messages      = lookup(each.value, "retain_acked_messages", null)
  filter                     = lookup(each.value, "filter", null)

  dynamic "expiration_policy" {
    for_each = contains(keys(each.value), "expiration_policy") ? [each.value.expiration_policy] : []
    content {
      ttl = expiration_policy.value
    }
  }

  dynamic "dead_letter_policy" {
    for_each = (lookup(each.value, "dead_letter_topic", "") != "") ? [each.value.dead_letter_topic] : []
    content {
      dead_letter_topic     = lookup(each.value, "dead_letter_topic", "")
      max_delivery_attempts = lookup(each.value, "max_delivery_attempts", "5")
    }
  }

  dynamic "retry_policy" {
    for_each = (lookup(each.value, "maximum_backoff", "") != "") ? [each.value.maximum_backoff] : []
    content {
      maximum_backoff = lookup(each.value, "maximum_backoff", "")
      minimum_backoff = lookup(each.value, "minimum_backoff", "")
    }
  }

  push_config {
    push_endpoint = each.value["push_endpoint"]

    attributes = {
      x-goog-version = lookup(each.value, "x-goog-version", "v1")
    }

    dynamic "oidc_token" {
      for_each = (lookup(each.value, "oidc_service_account_email", "") != "") ? [true] : []
      content {
        service_account_email = lookup(each.value, "oidc_service_account_email", "")
        audience              = lookup(each.value, "audience", "")
      }
    }
  }

  depends_on = [
    google_pubsub_topic.pubsub_topic
  ]
}
