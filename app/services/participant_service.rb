class ParticipantService
  def initialize(participant_list, owner)
    @list = participant_list
    @owner = owner
  end
  
  def participants_list
    names = []
    @list.split(",").each do |name|
      name = remove_goofy_whitespace_from(name)
      names << retrieve_participant_named(name)
    end
    return names
  end
  
  private
    def remove_goofy_whitespace_from( name )
      name.squeeze(" ").strip
    end
    
    def retrieve_participant_named( name )
      participant = Participant.find_by_name(name)
      if participant.nil?
        participant = Participant.create(:name => name, :user => @owner)
      end
      return participant
    end
end