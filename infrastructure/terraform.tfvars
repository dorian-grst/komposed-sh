cluster = {
  name         = "gryffondor"
  storage_pool = "gryffondor-pool"
  node         = "gryffondor-3"
  ssh_user     = "courtcircuits"
  ssh_key      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID50ksbMbCOdJv4CbO9pSbrqBZLoskgHYkPmPpBvBsEg tristan-mihai.radulescu@etu.umontpellier.fr"
  nodes = [{
    gw          = "162.38.112.254"
    id          = "201"
    interface   = "net0"
    ip          = "162.38.112.225"
    name        = "harry"
    nameservers = ["8.8.8.8"]
    role = "controlplane"
    }, {
    gw          = "162.38.112.254"
    id          = "202"
    interface   = "net0"
    ip          = "162.38.112.166"
    name        = "ron"
    nameservers = ["8.8.8.8"]
    role = "worker"
    },
    {
      gw          = "162.38.112.254"
      id          = "203"
      interface   = "net0"
      ip          = "162.38.112.220"
      name        = "hermione"
      nameservers = ["8.8.8.8"]
      role = "worker"
    }
  ]
}
