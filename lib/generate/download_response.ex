defimpl CWMP.Protocol.Generate, for: CWMP.Protocol.Messages.DownloadResponse do
  import XmlBuilder

  use CWMP.Protocol.GenerateHelpers

  def generate(req) do
    element("cwmp:DownloadResponse", [
      element(:Status,integerValue(req.status, fn(x) -> x in 0..1 end)),
      element(:StartTime,timeString(req.start_time)),
      element(:CompleteTime,timeString(req.complete_time))])
  end
end
