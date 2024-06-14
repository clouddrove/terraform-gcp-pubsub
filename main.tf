# main.tf


locals {
  default_ack_deadline_seconds = 10
}
# Resource for creating a Pub/Sub topic
resource "google_pubsub_topic" "pubsub_topic" {
  name = var.topic
}

# Conditional resource for creating pull subscriptions
resource "google_pubsub_subscription" "pull_subscriptions" {
  for_each = var.create_subscriptions ? { for i in var.pull_subscriptions : i.name => i } : {}

  name    = each.value.name
  topic   = var.create_topic ? google_pubsub_topic.topic[0].name : var.topic
  project = var.project_id
  labels  = var.subscription_labels
  enable_exactly_once_delivery = lookup(
    each.value,
    "enable_exactly_once_delivery",
    null,
  )
  ack_deadline_seconds = lookup(
    each.value,
    "ack_deadline_seconds",
    local.default_ack_deadline_seconds,
  )
  message_retention_duration = lookup(
    each.value,
    "message_retention_duration",
    null,
  )
  retain_acked_messages = lookup(
    each.value,
    "retain_acked_messages",
    null,
  )
  filter = lookup(
    each.value,
    "filter",
    null,
  )
  enable_message_ordering = lookup(
    each.value,
    "enable_message_ordering",
    null,
  )
  dynamic "expiration_policy" {
    // check if the 'expiration_policy' key exists, if yes, return a list containing it.
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
    google_pubsub_topic.topic,
  ]
}

############################## Push subscription ##################################

resource "google_pubsub_subscription" "push_subscriptions" {
  for_each = var.create_subscriptions ? { for i in var.push_subscriptions : i.name => i } : {}

  name    = each.value.name
  topic   = var.create_topic ? google_pubsub_topic.topic[0].name : var.topic
  project = var.project_id
  labels  = var.subscription_labels
  ack_deadline_seconds = lookup(
    each.value,
    "ack_deadline_seconds",
    local.default_ack_deadline_seconds,
  )
  message_retention_duration = lookup(
    each.value,
    "message_retention_duration",
    null,
  )
  retain_acked_messages = lookup(
    each.value,
    "retain_acked_messages",
    null,
  )
  filter = lookup(
    each.value,
    "filter",
    null,
  )
  dynamic "expiration_policy" {
    // check if the 'expiration_policy' key exists, if yes, return a list containing it.
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

    // FIXME: This should be programmable, but nested map isn't supported at this time.
    //   https://github.com/hashicorp/terraform/issues/2114
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
    google_pubsub_topic.topic,
  ]
}