
Chef.event_handler do
  on :run_completed do
    ReportHanders::WarHotelHandler.new.report
  end
end
