function univ-grep() {
  case ${OSTYPE} in
    darwin*)
      ggrep $@
      ;;
    linux*)
      grep $@
      ;;
  esac
}
