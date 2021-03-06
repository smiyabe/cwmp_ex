defimpl CWMP.Protocol.Generate, for: CWMP.Protocol.Messages.RequestDownload do
  import XmlBuilder

  def generate(req) do
    arglist=generateArgList(req.filetype_arg)
    element("cwmp:RequestDownload", [
      element(:FileType,req.filetype),
      element(:FileTypeArg, %{"SOAP-ENC:arrayType": "cwmp:ArgStruct[#{length(arglist)}]"}, arglist) ])
  end

  defp generateArgList(filetype_args) do
    for a <- filetype_args, do: element(:ArgStruct, [ element(:Name, a.name), element(:Value, a.value) ] )
  end

end
