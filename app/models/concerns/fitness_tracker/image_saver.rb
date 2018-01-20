class FitnessTracker::ImageSaver

  def initialize(user)
    @image_dir = File.join(Dir.pwd,"app","assets","images","users","#{user.id}")
  end

  def save_profile_pic(profile_pic)
    Dir.mkdir(@image_dir) unless Dir.exist?(@image_dir)
    if profile_pic.present?
      file_ext = File.extname(profile_pic.tempfile)
      File.open(File.join(@image_dir,"profile_pic#{file_ext}"), mode: "w", binmode: true){|file| file.write(File.read(profile_pic.tempfile, binmode: true))}
    else
      File.open(File.join(@image_dir,"profile_pic.png"), mode: "w", binmode: true){|file| file.write(File.read(File.join(Dir.pwd,"app","assets","images","users","generic","profile_pic.png"), binmode: true))}
    end
  end

  def update_profile_pic(profile_pic)
    file_ext = File.extname(profile_pic.tempfile)
    profile_pic_path = Dir.glob(File.join(@image_dir,"profile_pic*")).first
    !!File.open(profile_pic_path, mode: "w", binmode: true){|file| file.write(File.read(profile_pic.tempfile, binmode: true))}
  end

  def delete_user_image_dir
    files = Dir.entries(@image_dir)
    files = files - ["*","**"]
    files.each 
    File.delete(files.join())
    Dir.rmdir(@image_dir)
  end

end