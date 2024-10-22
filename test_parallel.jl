using Luxor

println("\ntest1")
test_parallel_dir = "test_parallel_dir1/"
try rm(test_parallel_dir, force=true, recursive=true); mkpath(test_parallel_dir) catch end 
function t1(i=0)
    println(i, " start on ", Threads.threadid())
    sleep(0.1)
    filename = "$i.png"
    Drawing(100, 100, test_parallel_dir*filename)
    origin()
    fontsize(20)
    sleep(0.1)
    text(filename, halign=:center, valign=:middle)
    sleep(0.1)
    println(i, " end on ", Threads.threadid())
    finish()
end

# for i in 1:10
#     t1(i)
# end

fetch.(Threads.@spawn t1(i) for i in 1:10)
println("All output files of t1:")
println(readdir(test_parallel_dir))

# ------

println("\ntest2")
test_parallel_dir = "test_parallel_dir2/"
try rm(test_parallel_dir, force=true, recursive=true); mkpath(test_parallel_dir) catch end 
function t2(i=0)
    println(i, " start on ", Threads.threadid())
    sleep(0.1)
    filename = "$i.png"
    d = Drawing(100, 100, test_parallel_dir*filename)
    origin(; drawing=d)
    fontsize(20; drawing=d)
    sleep(0.1)
    text(filename, halign=:center, valign=:middle; drawing=d)
    sleep(0.1)
    println(i, " end on ", Threads.threadid())
    finish(; drawing=d)
end

fetch.(Threads.@spawn t2(i) for i in 1:10)
println("All output files of t2:")
println(readdir(test_parallel_dir))