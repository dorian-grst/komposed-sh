variable "crds" {
  type = map(string)
  default = {
    "komposed.sh" = "https://raw.githubusercontent.com/dorian-grst/komposed-sh/refs/heads/main/operator/dist/install.yaml"
  }
}
