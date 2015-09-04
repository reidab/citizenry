PaperTrailManager.whodunnit_class = User

is_admin = proc { |controller| controller.current_user.try(:admin?) }
PaperTrailManager.allow_index_when(&is_admin)
PaperTrailManager.allow_show_when(&is_admin)
PaperTrailManager.allow_revert_when(&is_admin)
