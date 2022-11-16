import { Component, OnInit } from '@angular/core';
import { Store } from '@ngrx/store';
import * as d3 from 'd3';
import { Simulation } from 'd3-force';
import { tap } from 'rxjs/operators';
import {
  getACESSMState,
  getEntities,
  getRelations,
  getTaskStructure,
  IEntity,
} from '../redux/ace-ssm.reducer';

interface Node {
  // id: string;
  // group: number;
  name: string;
  x: number;
  y: number;
}

interface Link {
  source: string;
  target: string;
  value: number;
}

interface Graph {
  nodes: Node[];
  links: Link[];
}

@Component({
  selector: 'task-structure',
  templateUrl: './task-structure.component.html',
  styleUrls: ['./task-structure.component.scss'],
})
export class TaskStructureComponent implements OnInit {
  width = 1000;
  height = 1000;
  nodes: Array<IEntity> = [];
  links: Array<Object> = [];
  _nodes: Array<Node> = [];
  _links: Array<Object> = [];
  entityWidth = 120;
  entityHeight = 25;

  constructor(private store: Store<any>) {
    this.store
      .select(getEntities)
      .pipe(tap((entities) => (this.nodes = entities)))
      .subscribe();

    this.store
      .select(getRelations)
      .pipe(tap((relations) => (this.links = relations)))
      .subscribe();
  }

  ngOnInit() {
    this.width = document.body.getBoundingClientRect().width;
    this.height = document.body.getBoundingClientRect().height;
    const width = this.width;
    const height = this.height;

    this._nodes = this.nodes.map((node) => ({ ...node, x: 1, y: 1 })) || [];
    this._links = this.links;
    const simulation = d3
      .forceSimulation(this._nodes)
      .force(
        'link',
        d3.forceLink().id((d: any) => d.id)
      )
      .force('charge', d3.forceManyBody())
      .force('center', d3.forceCenter(this.width / 2, this.height / 2))
      .force('collision', d3.forceCollide().radius(120))
      .on('tick', ticked);

    const graph: Graph = <Graph>{ nodes: this._nodes, links: this._links };

    simulation.nodes(this._nodes);

    function ticked(this: Simulation<Node, undefined>) {
      console.log(this)
      this.nodes().forEach((node) => {
        node.x = Math.min(parseInt(node.x.toString()), width - 20);
        node.y = Math.min(parseInt(node.y.toString()), height - 20);

      });
      // node.attr("cx", (d: any) => d.x)
      //     .attr("cy", (d: any) => d.y);

      // link.attr("x1", (d: any) => d.source.x)
      //     .attr("y1", (d: any) => d.source.y)
      //     .attr("x2", (d: any) => d.target.x)
      //     .attr("y2", (d: any) => d.target.y);
    }

    // const ticked = (node: any) => {
    // 	node.attr("cx", (d: any) => d.x)
    // 		.attr("cy", (d: any) => d.y);
    // };

    // simulation
    // 	.nodes(graph.nodes)
    // 	.on('tick', ticked);

    // simulation.force<d3.ForceLink<any, any>>('link')
    // 	.links(graph.links)
    // 	.distance(100);

    // simulation.nodes(this._nodes);
    // simulation.force("link").links(this._links);
    // simulation.alpha(1).restart().tick();
    // ticked(); // render now!
  }
}
