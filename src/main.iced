{Summarizer} = require './dirsummary.iced'



await Summarizer.from_dir '.', defer err, s
console.log s.to_str()