# Routing_problems

This repository contains code written in MATLAB to solve complex network routing problem.

Problem 1. Consider a multi-hop wireless network which is modeled by a graph with L edges denoted by set
E = {e1;e2; : : : ;eL} and cost structure cl,l belongs to E, which represent the cost of any one transmission
attempt over link l. Furthermore, any edge el is assigned a packet loss probability pl . Packet
losses are detected instantaneously, and transmissions are repeated on a link until the packet is
successfully received. We are interested in routing a packet from a source node s to a destination
node t on a path P such that expected cost in minimized. How would you go about finding such
path? Can you define a Bellman type equation? Can you devise an algorithm? Implement your
algorithm in MATLAB and provide an instance of solution.

Problem 2. Consider Problem 1; this time assuming that the link failures are dealt with by end-end retransmissions:
if a packet is dropped the initial source node is informed and is given the task to to
initiate a new (possibly multi-hop) retransmission. Derive a fixed point equation, similar to the
Bellman Equation we studied in class, for the optimal expected cost to deliver a pack from nodes
i = 1;2;..., to a fixed destination; using this fixed-point equation, design an appropriate shortest
path algorithm. Implement your algorithm in MATLAB and provide the solution for the example
chosen for Problem 1.
