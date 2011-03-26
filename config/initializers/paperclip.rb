Paperclip.interpolates :safe_filename do |attachment, style| 
  filename(attachment, style).gsub(/#/, '-') 
end 
