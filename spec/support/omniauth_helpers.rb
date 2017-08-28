module OmniauthHelpers
  def create_auth(email: 'aaa@bbb.cc',
                  token: 'valid_token',
                  team_id: 'team_id',
                  team_name: 'team_name',
                  small_avatar: 'slack.com/sample_small_avatar_192.png',
                  big_avatar: 'slack.com/sample_avatar.png',
                  is_admin: false)
    {
      'provider' => 'slack',
      'uid' => 'auth_uid',
      'info' => {
        'name' => 'Tod T',
        'nickname' => 'tod',
        'email' => email,
        'team_id' => team_id,
        'team' => team_name,
        'is_admin' => is_admin,
        'image' => small_avatar,
      },
      'extra' => {
        'user_info' => {
          'user' => {
            'profile' => {
              'real_name' => 'Tod Tod',
              'image_512' => big_avatar,
            },
          },
        },
      },
      'credentials' => { 'token' => token },
    }
  end

  def users_list_array(users_number: 1,
                       email: 'aaa@bbb.cc',
                       id: 'slack_id',
                       name: 'mention',
                       real_name: 'John Doe',
                       big_avatar: 'slack.com/sample_avatar.png',
                       is_admin: false,
                       is_bot: false,
                       is_guest: false,
                       is_restricted: false,
                       is_ultra_restricted: false)
    users_list_array = []
    users_number.times do |i|
      i = i.to_s
      users_list_array <<
        {
          'id' => id + i,
          'name' => name + i,
          'deleted' => false,
          'real_name' => real_name + i,
          'profile' =>
          {
            'email' => i + email,
            'image_192' => i + '_small_version_' + big_avatar,
            'image_512' => i + big_avatar,
            'image_original' => i + '_original_' + big_avatar,
            'guest_channels' => is_guest ? ['chann_id'] : nil,
          },
          'is_admin' => is_admin,
          'is_bot' => is_bot,
          'is_restricted' => is_restricted,
          'is_ultra_restricted' => is_ultra_restricted,
        }
    end
    users_list_array
  end
end
