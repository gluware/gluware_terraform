terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

variable "api_host" {
  description = "The base URL or IP address of the API endpoint"
  type        = string
}

resource "null_resource" "get_devices" {
  provisioner "local-exec" {
    command = <<EOT
curl -k --location 'https://${var.api_host}/api/devices' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD"
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "get_organizations" {
  provisioner "local-exec" {
    command = <<EOT
curl -k --location 'https://${var.api_host}/api/organizations' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD"
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "get_organization_by_id" {
  provisioner "local-exec" {
    command = <<EOT
curl -k --location 'https://${var.api_host}/api/organizations/${var.gluware_device_id}' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD"
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "create_device" {
  provisioner "local-exec" {
    command = <<EOT
curl -X POST -k --location 'https://${var.api_host}/api/devices' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD" \
  --data '{
    "name": "device-name",
    "orgId": "${var.org_id}",
    "connectionInformation": {
      "ip": "10.0.0.1",
      "userName": "admin",
      "password": "password",
      "type": "ssh",
      "port": 22
    }
  }'
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "get_device_by_id" {
  provisioner "local-exec" {
    command = <<EOT
curl -k --location 'https://${var.api_host}/api/devices/${var.gluware_device_id}' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD"
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "update_device" {
  provisioner "local-exec" {
    command = <<EOT
curl -X PUT -k --location 'https://${var.api_host}/api/devices/${var.gluware_device_id}' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD" \
  --data '{
    "description": "Updated description"
  }'
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "delete_device" {
  provisioner "local-exec" {
    command = <<EOT
curl -X DELETE -k --location 'https://${var.api_host}/api/devices/${var.gluware_device_id}' \
  --header 'Content-Type: application/json' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD"
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "discover_device" {
  provisioner "local-exec" {
    command = <<EOT
curl -X POST -k --location 'https://${var.api_host}/api/devices/discover' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD" \
  --data '{
    "deviceIds": ["${var.gluware_device_id}"]
  }'
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "list_workflows" {
  provisioner "local-exec" {
    command = <<EOT
curl -k --location 'https://${var.api_host}/api/workflows' \
  --user "$GLU_USERNAME:$GLU_PASSWORD"
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "execute_workflow" {
  provisioner "local-exec" {
    command = <<EOT
curl -X POST -k --location 'https://${var.api_host}/api/workflows/{id}/run' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD"
EOT
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "capture_config" {
  provisioner "local-exec" {
    command = <<EOT
curl -X POST -k --location 'https://${var.api_host}/api/snapshots/capture' \
  --header 'Content-Type: application/json' \
  --user "$GLU_USERNAME:$GLU_PASSWORD" \
  --data '{
    "deviceIds": ["${var.gluware_device_id}"],
    "description": "Description for snapshot"
  }'
EOT
  }
    triggers = {
    always_run = "${timestamp()}"
  }
}
