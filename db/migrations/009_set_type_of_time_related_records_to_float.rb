# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    alter_table(:videos) do
      set_column_type :duration, :Float
    end

    alter_table(:timetags) do
      set_column_type :start_time, :Float
      set_column_type :end_time, :Float
      set_column_type :duration, :Float
    end
  end

  down do
    alter_table(:videos) do
      set_column_type :duration, :Integer
    end

    alter_table(:timetags) do
      set_column_type :start_time, :Integer
      set_column_type :end_time, :Integer
      set_column_type :duration, :Integer
    end
  end
end
