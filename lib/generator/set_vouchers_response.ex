defmodule CWMP.Protocol.Generator.Messages.SetVouchersResponse do
  import XmlBuilder

  def generate do
    element('cwmp:SetVouchersResponse', '')
  end
end

