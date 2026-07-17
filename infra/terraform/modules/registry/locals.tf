locals {

  repository_full_name = join("/",
    compact([
      var.repository_prefix,
      var.repository_name
    ])
  )
}