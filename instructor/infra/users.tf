# Workshop participants: invited as Conveyor users, grouped in one team,
# and given contributor access to the project and environment via that team,
# enough to create IDEs for the project in the environment.

resource "conveyor_user" "participant" {
  for_each = toset([for email in var.participants : lower(email)])

  email                 = each.value
  skip_invitation_email = true
}

resource "conveyor_team" "workshop" {
  name = "agent-skills-workshop"
}

resource "conveyor_team_user" "participant" {
  for_each = conveyor_user.participant

  team_id     = conveyor_team.workshop.id
  user_id     = each.value.email
  member_type = "member"
}

resource "conveyor_project_team" "workshop" {
  project_id = conveyor_project.workshop.id
  team_id    = conveyor_team.workshop.id
  role       = "contributor"
}

resource "conveyor_environment_team" "workshop" {
  environment_id = conveyor_environment.workshop.id
  team_id        = conveyor_team.workshop.id
  role           = "contributor"
}
