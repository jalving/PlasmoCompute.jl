#####################################################
# Computing Graph
#####################################################
mutable struct ComputingGraph <: AbstractComputingGraph
    #basegraph::BasePlasmoGraph
    multigraph::MultiGraph
    compute_nodes::Dict{Int64,ComputeNode}
    comm_edges::Dict{MultiEdge,CommunicationEdge}
    signalqueue::SignalQueue
    history_on::Bool
end
function ComputingGraph()

    #basegraph = BasePlasmoGraph(MultiGraph)
    #signal_priority_order =[signal_finalize(),signal_back_to_idle(),signal_receive(),signal_updated(),signal_sent(),signal_received(),signal_communicate(),signal_execute()]

    multigraph = MultiGraph()
    compute_nodes = Dict{Int64,ComputeNode}()
    comm_edges = Dict{MultiEdge,CommunicationEdge}()
    signal_priority_order =[signal_finalize(),signal_updated(),signal_back_to_idle(),signal_sent(),signal_received(),signal_communicate(),signal_receive(),signal_execute()]
    signalqueue = SignalQueue()
    signalqueue.signal_priority_order = signal_priority_order
    return ComputingGraph(multigraph,compute_nodes,comm_edges,signalqueue,true)
end


#####################################################
# Compute Nodes
#####################################################


#####################################################
# Communication Edges
#####################################################
# function getlinkedge(graph::ModelGraph,hyperedge::HyperEdge)
#     # d = merge(graph.linkedges,graph.sublinkedges)
#     # return d[hyperedge]
#     return graph.linkedges[hyperedge]
# end
#
# function getlinkedge(graph::ModelGraph,index::Int64)
#     hyperedge = gethyperedge(gethypergraph(graph),index)
#     return getlinkedge(graph,hyperedge)
# end
#
# function getlinkedge(graph::ModelGraph,vertices::Int...)
#     hyperedge = gethyperedge(graph.hypergraph,vertices...)
#     return getlinkedge(graph,hyperedge)
# end

#####################################################
# Signal Queue
#####################################################

getsignalqueue(graph::AbstractComputingGraph) = graph.signalqueue
getqueue(graph::AbstractComputingGraph) = getqueue(graph.signalqueue)
stop_graph() = stop_queue()
getcurrenttime(graph::AbstractComputingGraph) = getcurrenttime(graph.signalqueue)
now(graph::AbstractComputingGraph) = now(graph.signalqueue)

function getnexttime(graph::ComputingGraph)
    queue = getqueue(graph)
    times = unique(sort([val.time for val in values(queue)]))
    # if length(times) == 1
    #     next_time = times[1]
    # else
    #     next_time = times[2]    #this will be the next time currently in the queue
    # end
    next_time = times[1]
    return next_time
end

function getnextsignaltime(graph::ComputingGraph)
    queue = getqueue(graph)
    times = unique(sort([val.time for val in values(queue)]))
    next_time = times[1]
    return next_time
end

call!(graph::ComputingGraph,signal_event::SignalEvent) = call!(graph.signal_queue,signal_event)

#Queue Signal methods for computing graph
queuesignal!(graph::ComputingGraph,signal::AbstractSignal,target::SignalTarget,time::Number;source = nothing) =
                    queuesignal!(getsignalqueue(graph),signal,target,time,source = source,priority = getlocaltime(target))


#queuesignal!(graph::ComputingGraph,signal::Signal,source::ComputeNode,target::ComputeNode,time::Number) = queuesignal!(getsignalqueue(graph),signal,source,target,time,priority = getlocaltime(target))
