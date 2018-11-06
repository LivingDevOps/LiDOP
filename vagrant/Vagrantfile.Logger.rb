# $out_file = File.new('.debug.log', 'w')
# def $stdout.write string
#     log_datas=string
#     if log_datas.gsub(/\r?\n/, "") != ''
#         log_datas=::Time.now.strftime("%d.%m.%Y %T") + " " + log_datas.gsub(/\r\n/, "\n")
#     end
#     super log_datas
#     $out_file.write log_datas
#     $out_file.flush
# end
# def $stderr.write string
#     log_datas=string
#     if log_datas.gsub(/\r?\n/, "") != ''
#         log_datas=::Time.now.strftime("%d.%m.%Y %T") + " " + log_datas.gsub(/\r\n/, "\n")
#     end
#     super log_datas
#     $out_file.write log_datas
#     $out_file.flush
# end