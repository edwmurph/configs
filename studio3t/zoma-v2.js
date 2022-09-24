db.alarms.find({ status: 'OPEN' }).sort({ updated: -1 }).limit(2)

db.metrics
// .explain('executionStats')
.find({
  'metadata.target_id': '10.105.12.186'
})
.sort({ updated: -1 })
.limit( 20 )