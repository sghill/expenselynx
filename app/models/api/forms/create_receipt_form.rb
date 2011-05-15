class Api::Forms::CreateReceiptForm
  def fill_in request, user
    @request = request
    @body = ActiveSupport::JSON.decode(request.body)
    @user = user
    self
  end

  def receipt
    Receipt.new(
            :purchase_date => @body['purchase_date'] || Time.current,
            :total => @body['total'],
            :store_id => Store.find_or_create_by_name(@body['store_name']).id,
            :user => @user
    )
  end

  def method
    'POST'
  end

  def enctype
    'application/json'
  end

  def properties
            {:store_name => {
                    :required => true,
                    :format => 'string',
                    :description => 'The name of the store where the receipt is from.'
            },
            :purchase_date => {
                    :required => false,
                    :format => 'date',
                    :description => 'The date the purchase was made.'
            },
            :total => {
                    :required => true,
                    :format => 'numeric',
                    :description => 'The total of the receipt.'
            },
            :expensable => {
                    :required => false,
                    :format => 'boolean',
                    :description => 'Whether the receipt is expensable.'
            },
            :guests => {
                    :required => false,
                    :format => 'array',
                    :items => {:format => 'string'},
                    :description => 'The guests of the event.'
            },
            :note => {
                    :required => false,
                    :format => 'string',
                    :description => 'Any notes for the receipt.'
            }}
  end
end
