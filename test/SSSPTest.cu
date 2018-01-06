/**
 * @brief SSSP test program
 * @file
 */
#include "Static/ShortestPath/SSSP.cuh"
#include <Graph/GraphStd.hpp>
#include <Util/CommandLineParam.hpp>

int main(int argc, char* argv[]) {
    using namespace timer;
    using namespace hornets_nest;

    graph::GraphStd<vid_t, eoff_t> graph;
    CommandLineParam cmd(graph, argc, argv);

    auto h_weights = new weight_t[graph.nE()];
    host::generate_randoms(h_weights, graph.nE(), 0, 100);

    HornetInit hornet_init(graph.nV(), graph.nE(), graph.csr_out_offsets(),
                           graph.csr_out_edges());
    hornet_init.insertEdgeData(h_weights);

    HornetGraph hornet_graph(hornet_init);
    SSSP sssp(hornet_graph);
    sssp.set_parameters(0);

    Timer<DEVICE> TM;
    TM.start();

    sssp.run();

    TM.stop();
    TM.print("SSSP");

    auto is_correct = sssp.validate();
    std::cout << (is_correct ? "\nCorrect <>\n\n" : "\n! Not Correct\n\n");
    return is_correct;
}
