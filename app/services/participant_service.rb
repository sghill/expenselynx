class ParticipantService
  def initialize(owner)
    @owner = owner
  end
  
  def merge(participant_ids, name = "merged")
    receipts = collect_receipts_of_participants_to_merge(participant_ids)
    superparticipant = Participant.create(:name => name, :user => @owner)
    
    receipts.each do |r| 
      mod_participants_list = remove_and_destroy_to_be_merged_participants(r, participant_ids)
      mod_participants_list << superparticipant
      @owner.participants.build(superparticipant)
      @owner.save
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
    
    def remove_and_destroy_to_be_merged_participants( receipt, participant_ids )
      list = []
      receipt.participants.each do |p|
        if participant_ids.include?(p.id) 
          Participant.find(p.id).delete
          @owner.participants.delete(p)
          # @owner.save!
        else
          list << p
        end
      end
      return list
    end
    
    def collect_receipts_of_participants_to_merge( participant_ids )
      receipts = []
      participant_ids.each do |id|
        participant = Participant.find(id)
        participant.receipts.each { |r| receipts << r }
      end
      return receipts
    end
end