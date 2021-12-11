function terraform_workspace
  if test -e .terraform/environment
    cat .terraform/environment
  else if test -e terraform/.terraform/environment
    cat terraform/.terraform/environment
  else
    return 1
  end
end
