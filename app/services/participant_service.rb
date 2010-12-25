class ParticipantService
  def initialize(owner)
    @owner = owner
  end
  
  def merge(participant_ids, name = "merged")
    receipts = []
    participant_ids.each do |id|
      current_participant = Participant.find(id)
      current_participant.receipts.each { |r| receipts << r }
    end
    superparticipant = Participant.create(:name => name, :user => @owner)
    receipts.each do |r| 
      mod_participants_list = []
      r.participants.each do |p|
        mod_participants_list << p unless participant_ids.include?(p.id)
      end
      mod_participants_list << superparticipant
      r.update_attributes(:participants => mod_participants_list)
      r.save
    end
    return superparticipant
  end
  
  def participants_list(comma_list)
    return [] unless list_valid?(comma_list)
    names = []
    comma_list.split(",").each do |name|
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
    
    def list_valid?( list )
      !(list == "" || list.nil?)
    end
end