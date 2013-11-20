class CreateCalendarExceptions < ActiveRecord::Migration
  def change
    create_table :calendar_exceptions do |t|
      t.references :calendar, index: true
      t.date :date
    end
  end
end