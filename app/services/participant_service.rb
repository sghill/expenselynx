class ParticipantService
  def initialize(participant_list)
    @list = participant_list
  end
  
  def participants_list
    names = []
    @list.split(",").each do |name|
      names << remove_goofy_whitespace(name)
    end
    return names
  end
  
  private
    def remove_goofy_whitespace( name )
      name.squeeze(" ").strip
    end
end