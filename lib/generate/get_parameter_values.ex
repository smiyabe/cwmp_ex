defimpl CWMP.Protocol.Generate, for: CWMP.Protocol.Messages.GetParameterValues do
  import XmlBuilder

  def generate(req) do
    params=for p <- req.parameters, do: element(p.type, p.name)
    count=params |> length
    element("cwmp:GetParameterValues", [element(:ParameterNames,%{arrayType: "string[#{count}]"},params)])
  end
end

