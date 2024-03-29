
## **Lab from terraform in action book - charp 10**

Testing and refactoring

app1.tf > create iam user with permission on EC2 instance. Create inline policy and provisions AWS keys.
app2.tf > create iam user with persission on S3 bucket. Create inline policy and provisions AWS keys.
main.tf > create local "credentials" file using local_file to store user cred from aws. (not recommended way for production) 

## 10.2 Refactoring Terraform configuration

While the code may be suitable for the current use case, there are deficiencies that will result in long-term maintainability issues:

** Duplicated code—As new users and policies are provisioned, correspondingly more service files are required. 
This means a lot of copy/paste.
** Name collisions—Because of all the copy/paste, name collisions on resources are practically inevitable. You’ll waste time resolving silly name conflicts.
** Inconsistency—As the codebase grows, it becomes harder and harder to maintain uniformity, especially if PRs are being made by people who aren’t Terraform experts.

## 10.2.1 Modularizing code

The biggest refactoring improvement we can make is to put reusable code into modules. Not only does this solve the problem of duplicated code (i.e., resources in modules only have to be declared once), but it also solves the problems of name collisions (resources do not conflict with resources in other modules) and inconsistency (it’s difficult to mess up a PR if not much code is being changed).

The first step to modularizing an existing workspace is to identify opportunities for code reuse. Comparing app1.tf with app2.tf, the same three resources are declared in both: an IAM user, an IAM policy, and an IAM access key. Here is app1.tf

modules/iam :
- aws_iam_user
- aws_iam_user_policy
- aws_iam_access_key

```

                   ┌─────────────────────┐
  Inputs           │                     │      Outputs
                   │                     │
Name: string       │                     │      Credentials (string)
Policies : list    │                     │
         ───┬──┬─► │      modules/iam    ├─────►
                   │                     │
                   │                     │
                   │                     │
                   └─────────────────────┘
 

 module "iam-app1" {
  source   = "./modules/iam"
  name     = "app1"
  policies = [file("./policies/app1.json")]
}
 
module "iam-app2" {
  source   = "./modules/iam"
  name     = "app2"
  policies = [file("./policies/app2.json")]
}

```

## Terraform 0.13 introduces module expansion.

The use of modules expansion is the most recommended way for this use case, there is an example on module-expansion:
From book "terraform in action"

```

module-expansion/
├── credentials
├── main.tf
├── modules
│   └── iam
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── policies
│   ├── app1.json
│   └── app2.json
├── providers.tf
├── variables.tf
└── versions.tf

```


