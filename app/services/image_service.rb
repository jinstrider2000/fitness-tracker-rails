class ImageService

  def initialize(id)
    @image_dir = File.join(Dir.pwd,"app","assets","images","users","#{id}")
  end

  def self.save_profile_pic(id, params, flash)
    Dir.mkdir(@image_dir) unless Dir.exist?(@image_dir)
    File.open(File.join(@image_dir,"profile_pic.png"), mode: "w", binmode: true){|file| file.write(File.read(File.join(Dir.pwd,"app","assets","users","generic","profile_pic.png"), binmode: true))}
  end

  def self.update_profile_pic(id, params, flash)
    if image_present_and_valid?(params)
      profile_pic_array = profile_pic_dir_and_file(id)
      profile_pic_dir_w_file = profile_pic_array[0]
      new_pic_instance_num = profile_pic_array[1].split("_")[2].to_i + 1
      File.delete(profile_pic_dir_w_file)
      file_ext = File.extname(params[:profile_img][:filename])
      File.open("app/assets/images/users/#{id}/#{id}_profilepic_#{new_pic_instance_num}_#{file_ext}", mode: "w", binmode: true){|file| file.write(File.read(params[:profile_img][:tempfile], binmode: true))}
    else
      nil
    end
  end

  def self.delete_user_image_dir(id)
    
  end

  private

  def image_present_and_valid?(params)
    params[:profile_img] && !(params[:profile_img][:type] =~ /image/)
  end

  def self.profile_pic_dir_and_file(id)
    profile_pic_file = Dir.glob(File.join("public","images","users","#{id}","*profilepic*")).first.match(/(?<=\/)\d+_profilepic.+/)[0]
    [File.join("public","images","users","#{id}",profile_pic_file), profile_pic_file]
  end

end