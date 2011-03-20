class ParticipantService
  def initialize(owner)
    @owner = owner
  end

  def merge(participant_ids, name = "merged")
    participants = Participant.where(:id => participant_ids)
    participants_receipts = participants.map(&:receipts).flatten
    super_participant = Participant.create(:name => name, :user => @owner)

    participants_receipts.each do |receipt|
      mod_participants_list = remove_and_destroy_to_be_merged_participants(receipt, participants)
      mod_participants_list << super_participant
      @owner.participants.build(super_participant)
      @owner.save
      receipt.update_attributes(:participants => mod_participants_list)
      receipt.save
    end
    super_participant
  end

  def participants_list(comma_list)
    return [] unless list_valid?(comma_list)
    comma_list.split(",").map do |name|
      name = remove_goofy_whitespace_from(name)
      retrieve_participant_named(name)
    end
  end

  def participants_list_from_collection(collection)
    collection.map do |name|
      name = remove_goofy_whitespace_from(name)
      retrieve_participant_named(name)
    end
  end

  private
  def remove_goofy_whitespace_from(name)
    name.squeeze(" ").strip
  end

  def retrieve_participant_named(name)
    Participant.find_or_create_by_name(:name => name, :user => @owner)
  end

  def list_valid?(list)
    list.present?
  end

  def remove_and_destroy_to_be_merged_participants(receipt, participants)
    list = []
    receipt.participants.each do |participant|
      if participants.include?(participant)
        participant.delete
        @owner.participants.delete(participant)
      else
        list << participant
      end
    end
    list
  end
end
