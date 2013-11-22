require "softlayer/object_storage"

@softlayer = SoftLayer::ObjectStorage::Connection.new({
  username: 'SLOS290320-2:puhsh',
  api_key: 'dac2f876ceda6296cee89ddafacb0e115b3e96cb946456a1580ab2760502d29b',
  datacenter: :dal05
})
