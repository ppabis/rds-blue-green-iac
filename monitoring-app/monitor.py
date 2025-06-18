import threading, time, signal, sys
from check_mysql import check_mysql

class Monitor:
    def __init__(self, mode="mysql", args=None):
        self.mode = mode
        self.active = False
        self.args = args
        self.thread = threading.Thread(target=self.run, daemon=True)
        signal.signal(signal.SIGINT, self.signal_handler)
        signal.signal(signal.SIGTERM, self.signal_handler)
        
    def run(self):
        while self.active:
            try:
                time.sleep(1)
                if self.mode == "mysql":
                    check_mysql(**self.args)
            except Exception as e:
                print(f"Error in monitoring thread: {e}")
                import traceback
                traceback.print_exc()
                break

    def stop(self):
        self.active = False
        if self.thread and self.thread.is_alive():
            self.thread.join(timeout=5)

    def start(self):
        self.active = True
        self.thread.start()

    def signal_handler(self, signum, frame):
        print(f"Received signal {signum}, shutting down...")
        self.stop()
        sys.exit(0)
