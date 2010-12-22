class ParticipantService
  def initialize(participant_list, owner)
    @list = participant_list
    @owner = owner
  end
  
  def participants_list
    return [] unless list_valid?
    names = []
    @list.split(",").each do |name|
      name = remove_goofy_whitespace_from(name)
      names << retrieve_participant_named(name)
    end
    return names
  end
  
  def participants_list_from_collection( collection )
    names = []
    collection.each do |name|
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
      Participant.find_or_create_by_name(:name => name, :user => @owner)
    end
    
    def list_valid?
      !(@list == "" || @list.nil?)
    end
end