class TeamMemberSerializer < ApplicationSerializer
  def self.render(member)
    {
      id:            member.id,
      name:          member.name,
      role:          member.role,
      bio:           member.bio,
      featured:      member.featured,
      position:      member.position,
      instagram_url: member.instagram_url,
      photo_url:     attachment_url(member.photo)
    }
  end
end
