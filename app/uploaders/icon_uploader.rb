# encoding: utf-8

class IconUploader < ImageUploader
  # Create different versions of your uploaded files:
  version :icon do
    process :resize_to_fill => [60,60]
  end
end
