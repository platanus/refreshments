require 'rails_helper'

RSpec.describe Withdrawal, type: :model do
  def stub_withdrawal_requests_worker
    worker = class_double('WithdrawalRequestsWorker')
    allow(worker).to receive(:perform_async)
    worker
  end

  def create_withdrawal_with_mocked_worker
    withdrawal = build(:withdrawal, user: user_with_invoice)
    withdrawal.instance_variable_set(:@withdrawal_request_worker, stub_withdrawal_requests_worker)
    withdrawal.save!
    withdrawal
  end

  def create_withdrawal_without_callback
    withdrawal = build(:withdrawal, user: user_with_invoice)
    allow(withdrawal).to receive(:add_job_to_withdrawal_requests_worker).and_return(true)
    withdrawal.save!
    withdrawal
  end

  let(:user_with_invoice) { create(:user_with_invoice) }

  context 'basic validations' do
    subject { create_withdrawal_without_callback }

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should belong_to(:user) }
  end

  context 'insufficient funds validations' do
    let(:withdrawal) { build(:withdrawal, user: user_with_invoice, amount: 100001) }

    it 'should raise validation error' do
      expect { withdrawal.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should only add "no funds" error' do
      withdrawal.valid?
      errors = withdrawal.errors.messages
      expect(errors.length).to eq(1)
      expect(errors[:amount]).to include(I18n.t(:cant_exceed_withdrawable_amount,
        scope: [:activerecord, :errors, :models, :withdrawal, :attributes, :amount]))
    end

    it 'should not create instance in database' do
      withdrawal.save
      expect(Withdrawal.all.count).to eq(0)
    end
  end

  context 'btc address validations' do
    context "incorrect first character" do
      it 'should raise validation error' do
        expect do
          create(:withdrawal,
            user: user_with_invoice,
            btc_address: 'AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "too short" do
      it 'should raise validation error' do
        expect do
          create(:withdrawal, user: user_with_invoice, btc_address: '1AGNa15ZQXAZUgFiqJ2i7Z')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "too long" do
      it 'should raise validation error' do
        expect do
          create(:withdrawal,
            user: user_with_invoice,
            btc_address: '1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i5g')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "has a 'I'" do
      it 'should raise validation error' do
        expect do
          create(:withdrawal,
            user: user_with_invoice,
            btc_address: '1AGNa15ZQXAZUgFIqJ2i7Z2DPU2J6hW62i')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "has a 'l'" do
      it 'should raise validation error' do
        expect do
          create(:withdrawal,
            user: user_with_invoice,
            btc_address: '1AGNa15ZQXAZUgFlqJ2i7Z2DPU2J6hW62i')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "has a 'O'" do
      it 'should raise validation error' do
        expect do
          create(:withdrawal,
            user: user_with_invoice,
            btc_address: '1AGNa15ZQOZUgF1qJ2i7Z2DPU2J6hW62i')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "has a '0'" do
      it 'should raise validation error' do
        expect do
          create(:withdrawal,
            user: user_with_invoice,
            btc_address: '1AGNa15ZQ0AZUgF1qJ2i7Z2DPU2J6hW62i')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'handle states correctly' do
    let(:withdrawal) { create_withdrawal_without_callback }

    it 'starts with default "pending" state' do
      expect(withdrawal.aasm.current_state).to eq(:pending)
    end

    it 'changes state to "confirmed" correctly' do
      withdrawal.confirm
      expect(withdrawal.aasm.current_state).to eq(:confirmed)
    end

    it 'changes state to "rejected" correctly' do
      withdrawal.reject
      expect(withdrawal.aasm.current_state).to eq(:rejected)
    end
  end

  context 'after create commit hook' do
    it 'calls the corresponding callback' do
      withdrawal = create_withdrawal_without_callback
      expect(withdrawal).to have_received(:add_job_to_withdrawal_requests_worker)
    end

    it 'calls the right method of its withdrawal request worker with param id' do
      withdrawal = create_withdrawal_with_mocked_worker
      expect(withdrawal.instance_variable_get(:@withdrawal_request_worker))
        .to have_received(:perform_async).with(withdrawal.id)
    end
  end
end
