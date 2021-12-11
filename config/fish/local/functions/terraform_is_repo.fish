function terraform_is_repo
  if test -d .terraform
    return 0
  else if test -d terraform/.terraform
    return 0
  else
    return 1
  end
end
