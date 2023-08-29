<?php

class DB {
    public static ?DB $instance = null;

    private function __construct(public array $config) {
        echo 'Instance Created'; echo "<br/>";
    }

    public static function getInstance(array $config): DB {
        if (self::$instance === null) {
            self::$instance = new DB($config);
        }

        return self::$instance;
    }
}
