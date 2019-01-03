require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe WithdrawalRequestsWorker, type: :worker do
  def initialize_user(withdrawable_amount)
    user = instance_double(User)
    allow(user).to receive(:withdrawable_amount).and_return(withdrawable_amount)
    user
  end

  def initialie_withdrawal(user, amount)
    withdrawal = instance_double(Withdrawal)
    allow(withdrawal).to receive(:user).and_return(user)
    allow(withdrawal).to receive(:amount).and_return(amount)
    allow(withdrawal).to receive(:reject!)
    allow(withdrawal).to receive(:confirm!)
    withdrawal
  end

  def initialize_response(code, errors)
    response = double('response')
    allow(response).to receive(:code).and_return(code)
    allow(response).to receive(:body)
      .and_return({ withdrawal: { errors: errors } }.to_json)
    response
  end

  def initialize_withdrawal_class(withdrawal)
    allow(Withdrawal).to receive(:find) do |withdrawal_id|
      withdrawal_id == 1 ? withdrawal : nil
    end
  end

  def initialize_create_btc_withdrawal_command(response)
    allow(CreateBTCWithdrawal).to receive(:for).and_return(response)
  end

  def initialize_context(withdrawable_amount, amount, code, errors)
    user = initialize_user(withdrawable_amount)
    withdrawal = initialie_withdrawal(user, amount)
    response = initialize_response(code, errors)
    initialize_withdrawal_class(withdrawal)
    initialize_create_btc_withdrawal_command(response)
    withdrawal
  end

  describe 'standard job creation' do
    it 'add the job to the queue' do
      expect { WithdrawalRequestsWorker.perform_async(1) }
        .to change(WithdrawalRequestsWorker.jobs, :size).by(1)
    end
  end

  Sidekiq::Worker.clear_all

  describe 'invalid withdrawal id' do
    let!(:withdrawal) { initialize_context(nil, nil, nil, nil) }

    it 'does not throw error with invalid id' do
      WithdrawalRequestsWorker.new.perform(-1)
    end
  end

  describe 'with invalid Buda response code' do
    let!(:withdrawal) { initialize_context(10, 9, 400, nil) }
    before { WithdrawalRequestsWorker.new.perform(1) }

    it 'rejects withdrawal' do
      expect(withdrawal).to have_received(:reject!)
    end
  end

  describe 'with errors in Buda response' do
    let!(:withdrawal) { initialize_context(10, 9, 400, ["some error"]) }
    before { WithdrawalRequestsWorker.new.perform(1) }

    it 'rejects withdrawal' do
      expect(withdrawal).to have_received(:reject!)
    end
  end

  describe 'with buda success' do
    let!(:withdrawal) { initialize_context(10, 9, 201, []) }
    before { WithdrawalRequestsWorker.new.perform(1) }

    it 'confirms withdrawal' do
      expect(withdrawal).to have_received(:confirm!)
    end

    it 'calls CreateBTCWithdrawal with correct params' do
      expect(CreateBTCWithdrawal).to have_received(:for).with(withdrawal: withdrawal)
    end
  end
end
