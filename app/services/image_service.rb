class ImageService

  def initialize(user)
    @image_dir = File.join(Dir.pwd,"app","assets","images","users","#{user.id}")
  end

  def save_profile_pic(params)
    Dir.mkdir(@image_dir) unless Dir.exist?(@image_dir)
    if params[:profile_img].present? && image_valid?(params)
      file_ext = File.extname(params[:profile_img].tempfile)
      !!File.open(File.join(@image_dir,"profile_pic#{file_ext}"), mode: "w", binmode: true){|file| file.write(File.read(params[:profile_img].tempfile, binmode: true))}
    elsif !params[:profile_img].present?
      !!File.open(File.join(@image_dir,"profile_pic.png"), mode: "w", binmode: true){|file| file.write(File.read(File.join(Dir.pwd,"app","assets","images","users","generic","profile_pic.png"), binmode: true))}
    else
      false
    end
  end

  def update_profile_pic(params)
    if params[:profile_img].present? && image_valid?(params)
      file_ext = File.extname(params[:profile_img].tempfile)
      profile_pic_path = Dir.glob(File.join(@image_dir,"profile_pic*")).first
      !!File.open(profile_pic_path, mode: "w", binmode: true){|file| file.write(File.read(params[:profile_img].tempfile, binmode: true))}
    elsif !params[:profile_img].present?
      true
    else
      false
    end
  end

  def delete_user_image_dir
    Dir.rmdir(@image_dir)
  end

  private

  def image_valid?(params)
    !!(params[:profile_img].content_type =~ /image/)
  end

end