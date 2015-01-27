PaperTrailManager.whodunnit_class = User

PaperTrailManager.allow_index_when { |c|
  c.authenticate_user!
  c.current_user && c.current_user.admin?
}

PaperTrailManager.allow_show_when { |c|
  c.authenticate_user!
  c.current_user && c.current_user.admin?
}

PaperTrailManager.allow_revert_when { |c|
  c.authenticate_user!
  c.current_user && c.current_user.admin?
}
