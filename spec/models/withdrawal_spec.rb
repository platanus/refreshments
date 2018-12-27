require 'rails_helper'

RSpec.describe Withdrawal, type: :model do
  context 'basic validations' do
    let!(:user) { create_user_with_invoice(100, 100, 5000) }
    subject { create(:withdrawal, user: user) }

    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should belong_to(:user) }
  end

  context 'amount validations' do
    context 'with insufficient funds' do
      let(:user) { create_user_with_invoice(100, 100, 5000) }

      it 'should raise validation error' do
        expect { create(:withdrawal, user: user, amount: 5001) }
          .to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'should only add "no funds" error' do
        withdrawal = build(:withdrawal, user: user, amount: 5001)
        withdrawal.valid?
        expect(withdrawal.errors.messages.length).to eq(1)
        expect(withdrawal.errors.messages[:amount])
          .to include("Amount can't be greater than user balance")
      end

      it 'should not create instance in database' do
        build(:withdrawal, user: user, amount: 5001).save
        expect(Withdrawal.all.count).to eq(0)
      end
    end

    context 'with sufficient funds' do
      let(:user) { create_user_with_invoice(100, 100, 5000) }

      it 'should raise validation error' do
        create(:withdrawal, user: user, amount: 5000)
        expect(Withdrawal.all.count).to eq(1)
      end
    end
  end

  context 'btc address validations' do
    context 'with invalid address' do
      let(:user) { create_user_with_invoice(100, 100, 5000) }

      context "incorrect first character" do
        it 'should raise validation error' do
          expect do
            create(:withdrawal, user: user, btc_address: 'AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i')
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "too short" do
        it 'should raise validation error' do
          expect do
            create(:withdrawal, user: user, btc_address: '1AGNa15ZQXAZUgFiqJ2i7Z')
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "too long" do
        it 'should raise validation error' do
          expect do
            create(:withdrawal, user: user, btc_address: '1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i5g')
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "has a 'I'" do
        it 'should raise validation error' do
          expect do
            create(:withdrawal, user: user, btc_address: '1AGNa15ZQXAZUgFIqJ2i7Z2DPU2J6hW62i')
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "has a 'l'" do
        it 'should raise validation error' do
          expect do
            create(:withdrawal, user: user, btc_address: '1AGNa15ZQXAZUgFlqJ2i7Z2DPU2J6hW62i')
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "has a 'O'" do
        it 'should raise validation error' do
          expect do
            create(:withdrawal, user: user, btc_address: '1AGNa15ZQOZUgF1qJ2i7Z2DPU2J6hW62i')
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end

      context "has a '0'" do
        it 'should raise validation error' do
          expect do
            create(:withdrawal, user: user, btc_address: '1AGNa15ZQ0AZUgF1qJ2i7Z2DPU2J6hW62i')
          end.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  context 'handle states correctly' do
    let(:user) { create_user_with_invoice(100, 100, 5000) }
    let(:withdrawal) { create(:withdrawal, user: user) }

    it 'starts with default "pending" state' do
      expect(withdrawal.aasm.current_state).to eq(:pending)
    end

    it 'changes state to "confirmed" correctly' do
      withdrawal.confirm
      expect(withdrawal.aasm.current_state).to eq(:confirmed)
    end
  end
end
