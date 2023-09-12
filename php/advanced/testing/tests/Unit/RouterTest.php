<?php

declare(strict_types=1);

require_once 'classes/RouteNotFoundException.php';
require_once 'classes/Router.php';

use PHPUnit\Framework\TestCase;

class RouterTest extends TestCase {

    protected function setUp(): void {
        parent::setUp();
        // $this->router = new Router();
    }

    public function test_it_registers_a_router(): void {
        // given that we have a router object
        $router = new Router();

        // when we call a register method
        $router->register('get', '/users', ['Users', 'index']);
        $expected = [
            'get' => [
                '/users' => ['Users', 'index']
            ]
        ];

        // then we assert route was registered
        // we also have assertSame() to compare value and type
        $this->assertEquals($expected, $router->routes());
    }

    public function there_are_no_routes_when_router_is_created(): void {
        // given
        $router = new Router();

        // then
        $this->assertEmpty($router->routes());
    }
}
