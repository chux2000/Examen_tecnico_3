resource "upcloud_server" "server1" {
  # System hostname
  hostname = "produccion.kukenan.net"

  # Availability zone
  zone = "us-nyc1"

  # Number of CPUs and memory in GB
  plan = "1xCPU-1GB"

  template {
    # System storage device size
    size = 25

    # Template UUID for Ubuntu 20.04
    storage = "01000000-0000-4000-8000-000030200200"
  }

  # Network interfaces
  network_interface {
    type = "public"
  }


  network_interface {
    type = "utility"
  }

  # Include at least one public SSH key
  login {
    user = "root"
    keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDDn9+CRRHrX42qbTx9IYgLZeazkY3hb/s7CmfXeHI/ST6susO8CBPGoKudbToJUrZ4HTAM9etrgjYDhjveH2lZ3Nv9bjlkSvW1yevRqgPeYM9njhKJUg+p+xsgzn5Vow7EvFIrOa9vCuvEMM/BlS9gJx+k2C0DN92VsO5lXUOgzKqSxGhu2Y76JTPFDa7VR/CYEAYleWKYZOzit6HgMBqjsAVqpmI7wDhgwSwbLm0NjWMj3WgM1bqphy9p0jV2riHMPe+1UVMVIQJ36a84ifmCT4aKN1IqGbA79KXSaDNKepzKthHTxU67yliVfZ9pwUSrb8kLkHVBIASTvb4odP0Dm0VMwoLcISTm1Q6xDRMXoAY8oQTObKcC/1/dq85KcxFTtJ6hZZtVTtI6psLQXwWZPRxIpOxdMn3aIRLNfCphjle0xB8jHSaV6YP9UF5GzZG+jW+r0PED0appX5noTzSURT/GX4UXaGmssCcKq1MdzcTK1i/FhXy5m2n8lnvmnuU= root@IMAGINA",
	]
    create_password = true
    password_delivery = "email"
  }

  # Configuring connection details
  connection {
    # The server public IP address
    host        = self.network_interface[0].ip_address
    type        = "ssh"
    user        = "root"
    private_key = file("id_rsa")
  }

  # Remotely executing a command on the server
  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install dnsutils net-tools nmap dnstracer -y "
    ]
  }

 provisioner "remote-exec" {
   inline = [
     "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
   ]
 }
 provisioner "remote-exec" {
   inline = [
     "docker run -it -d -p 80:9000 -p 81:9001 -p 82:5901 -e VNC_PASSWD=chux2000  -e USER_PASSWD=chux2000 clayvnc"
   ]
 }
}
